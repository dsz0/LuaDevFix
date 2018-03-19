using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using System;
using LuaInterface;

//using System.Net;

namespace LuaFramework {
    public class RazByteBuffer {
        MemoryStream stream = null;
        BinaryWriter writer = null;
        BinaryReader reader = null;

        int size = -1;
        int pid = -1;
        int ctxId = -1;

        public int GetSize()
        {
            return size;
        }

        public void SetSize(int _size)
        {
            size = _size;
        }

        public int GetPid()
        {
            return pid;
        }

        public void SetPid(int _pid)
        {
            pid = _pid;
        }

        public int GetCtxId()
        {
            return ctxId;
        }

        public void SetCtxId(int _ctxId)
        {
            ctxId = _ctxId;
        }

        public RazByteBuffer() {
            stream = new MemoryStream();
            writer = new BinaryWriter(stream);
        }

        public RazByteBuffer(byte[] data) {
            if (data != null) {
                stream = new MemoryStream(data);
                reader = new BinaryReader(stream);
            } else {
                stream = new MemoryStream();
                writer = new BinaryWriter(stream);
            }
        }

        public void Close() {
            if (writer != null) writer.Close();
            if (reader != null) reader.Close();

            stream.Close();
            writer = null;
            reader = null;
            stream = null;
        }

        public void WriteByte(byte v) {
            writer.Write((byte)v);
        }

        public void WriteInt(int v) {
            writer.Write((int)v);
        }

        public void WriteShort(ushort v) {
            writer.Write((ushort)v);
        }

        public void WriteLong(long v) {
            writer.Write((long)v);
        }

        public void WriteFloat(float v) {
            byte[] temp = BitConverter.GetBytes(v);
            Array.Reverse(temp);
            writer.Write(BitConverter.ToSingle(temp, 0));
        }

        public void WriteDouble(double v) {
            byte[] temp = BitConverter.GetBytes(v);
            Array.Reverse(temp);
            writer.Write(BitConverter.ToDouble(temp, 0));
        }

        public void WriteString(string v) {
            byte[] bytes = Encoding.UTF8.GetBytes(v);
            writer.Write(bytes);
            writer.Write(v);
        }

        public void WriteBytes(byte[] v) {
            writer.Write(v);
        }

        public void WriteBuffer(LuaByteBuffer strBuffer) {
            WriteBytes(strBuffer.buffer);
        }

        //方便调用, Int64 - long, Int32 -int, Int16 - short, Int8 - sbyte
        public void WriteInt64(Int64 v) {
            writer.Write((Int64)v);
        }

        public void WriteInt32(Int32 v) {
            writer.Write((Int32)v);
        }

        public void WriteInt16(Int16 v) {
            writer.Write((Int16)v);
        }

        public void WriteInt8(sbyte v) {
            writer.Write((sbyte)v);
        }
        
        public void WriteStringWithLen(string v, int len = 50) {
            byte[] outData = new byte[len];

            if (v == null)
            {
                v = "";
            }

            byte[] bytes = UTF8Encoding.UTF8.GetBytes(v);
            for (int i = 0; i < bytes.Length; i++)
            {
                outData[i] = bytes[i];
            }

            if(bytes.Length < len)
            {
                outData[bytes.Length] = 0;
            }

            writer.Write(outData);
        }


        public byte ReadByte() {
            return reader.ReadByte();
        }

        public Boolean ReadBoolean() {
            Boolean b = Convert.ToBoolean(reader.ReadByte());
            return b;
        }


        public int ReadInt() {
            return (int)reader.ReadInt32();
        }

        public ushort ReadShort() {
            return (ushort)reader.ReadInt16();
        }

        public long ReadLong() {
            long l = (long)reader.ReadInt64();
            return l;
        }

        public float ReadFloat() {
            byte[] temp = BitConverter.GetBytes(reader.ReadSingle());
            Array.Reverse(temp);
            return BitConverter.ToSingle(temp, 0);
        }

        public double ReadDouble() {
            byte[] temp = BitConverter.GetBytes(reader.ReadDouble());
            Array.Reverse(temp);
            return BitConverter.ToDouble(temp, 0);
        }

        public string ReadString(int len) {
            byte[] buffer = new byte[len];
            buffer = reader.ReadBytes(len);
            return Encoding.UTF8.GetString(buffer);
        }

        public string ReadString() {
            ushort len = ReadShort();
            byte[] buffer = new byte[len];
            buffer = reader.ReadBytes(len);
            return Encoding.UTF8.GetString(buffer);
        }

        public byte[] ReadBytes() {
            int len = ReadInt();
            return reader.ReadBytes(len);
        }

        public LuaByteBuffer ReadBuffer() {
            byte[] bytes = ReadBytes();
            return new LuaByteBuffer(bytes);
        }

        public byte[] ToBytes() {
            writer.Flush();
            return stream.ToArray();
        }

        public void Flush() {
            writer.Flush();
        }
    }
}