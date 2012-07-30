From: Markus Rathgeb <maggu2810@googlemail.com>
Subject: Re: [PATCH SCSI] sr: check_events() ignore GET_EVENT when TUR says otherwise
Date: Mon, 30 Jul 2012 21:06:48 +0200
Message-ID: <CAOcK=CMPjZGNMiPS9LJMG6=t7sbLxjSkTikwRL2nhq6tewfofQ@mail.gmail.com>
References: <20110630130348.GQ3386@htj.dyndns.org>
	<20110720163308.GC9924@mtj.dyndns.org>
	<CAPXgP11R=386wbqpOpymzdXYYhpvJg9Aj1Xck3wi91smud-8iA@mail.gmail.com>
	<1311180316.8570.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae9340435a007cd04c610c3e9
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <1311180316.8570.1.camel@mulgrave>
Sender: linux-hotplug-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--14dae9340435a007cd04c610c3e9
Content-Type: text/plain; charset=UTF-8

Hello!

Do you remember?
I get it again, is there something I could do?

I attached a file that contains the "udevadm monitor" log.

I am using a v3.5.0 linux kernel (containing some gentoo patches).
Should I test it with a vanilla one?

Here the versions of some packages (kernel, udev, systemd):
sys-kernel/gentoo-sources-3.5.0
sys-fs/udev-186
sys-apps/systemd-44-r1


Here (again) the information about the two sticks I run in trouble
after plug them in:

# udevadm info --path=/block/sdb
P: /devices/pci0000:00/0000:00:04.1/usb5/5-4/5-4:1.0/host22/target22:0:0/22:0:0:0/block/sdb
N: sdb
S: disk/by-id/usb-SanDisk_Cruzer_07745302FB131CFA-0:0
S: disk/by-path/pci-0000:00:04.1-usb-0:4:1.0-scsi-0:0:0:0
E: DEVLINKS=/dev/disk/by-id/usb-SanDisk_Cruzer_07745302FB131CFA-0:0
/dev/disk/by-path/pci-0000:00:04.1-usb-0:4:1.0-scsi-0:0:0:0
E: DEVNAME=/dev/sdb
E: DEVPATH=/devices/pci0000:00/0000:00:04.1/usb5/5-4/5-4:1.0/host22/target22:0:0/22:0:0:0/block/sdb
E: DEVTYPE=disk
E: ID_BUS=usb
E: ID_DRIVE_THUMB=1
E: ID_INSTANCE=0:0
E: ID_MODEL=Cruzer
E: ID_MODEL_ENC=Cruzer\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
E: ID_MODEL_ID=5406
E: ID_PART_TABLE_TYPE=dos
E: ID_PATH=pci-0000:00:04.1-usb-0:4:1.0-scsi-0:0:0:0
E: ID_PATH_TAG=pci-0000_00_04_1-usb-0_4_1_0-scsi-0_0_0_0
E: ID_REVISION=8.02
E: ID_SERIAL=SanDisk_Cruzer_07745302FB131CFA-0:0
E: ID_SERIAL_SHORT=07745302FB131CFA
E: ID_TYPE=disk
E: ID_USB_DRIVER=usb-storage
E: ID_USB_INTERFACES=:080650:
E: ID_USB_INTERFACE_NUM=00
E: ID_VENDOR=SanDisk
E: ID_VENDOR_ENC=SanDisk\x20
E: ID_VENDOR_ID=0781
E: LVM_SBIN_PATH=/sbin
E: MAJOR=8
E: MINOR=16
E: SUBSYSTEM=block
E: TAGS=:systemd:
E: UDISKS_PARTITION_TABLE=1
E: UDISKS_PARTITION_TABLE_COUNT=1
E: UDISKS_PARTITION_TABLE_SCHEME=mbr
E: UDISKS_PRESENTATION_NOPOLICY=0
E: USEC_INITIALIZED=79287950141


# udevadm info --path=/block/sdb
P: /devices/pci0000:00/0000:00:04.1/usb5/5-4/5-4:1.0/host23/target23:0:0/23:0:0:0/block/sdb
N: sdb
S: disk/by-id/usb-SanDisk_Cruzer_22427202FB10CD97-0:0
S: disk/by-path/pci-0000:00:04.1-usb-0:4:1.0-scsi-0:0:0:0
E: DEVLINKS=/dev/disk/by-id/usb-SanDisk_Cruzer_22427202FB10CD97-0:0
/dev/disk/by-path/pci-0000:00:04.1-usb-0:4:1.0-scsi-0:0:0:0
E: DEVNAME=/dev/sdb
E: DEVPATH=/devices/pci0000:00/0000:00:04.1/usb5/5-4/5-4:1.0/host23/target23:0:0/23:0:0:0/block/sdb
E: DEVTYPE=disk
E: ID_BUS=usb
E: ID_DRIVE_THUMB=1
E: ID_INSTANCE=0:0
E: ID_MODEL=Cruzer
E: ID_MODEL_ENC=Cruzer\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
E: ID_MODEL_ID=5406
E: ID_PART_TABLE_TYPE=dos
E: ID_PATH=pci-0000:00:04.1-usb-0:4:1.0-scsi-0:0:0:0
E: ID_PATH_TAG=pci-0000_00_04_1-usb-0_4_1_0-scsi-0_0_0_0
E: ID_REVISION=8.02
E: ID_SERIAL=SanDisk_Cruzer_22427202FB10CD97-0:0
E: ID_SERIAL_SHORT=22427202FB10CD97
E: ID_TYPE=disk
E: ID_USB_DRIVER=usb-storage
E: ID_USB_INTERFACES=:080650:
E: ID_USB_INTERFACE_NUM=00
E: ID_VENDOR=SanDisk
E: ID_VENDOR_ENC=SanDisk\x20
E: ID_VENDOR_ID=0781
E: LVM_SBIN_PATH=/sbin
E: MAJOR=8
E: MINOR=16
E: SUBSYSTEM=block
E: TAGS=:systemd:
E: UDISKS_PARTITION_TABLE=1
E: UDISKS_PARTITION_TABLE_COUNT=1
E: UDISKS_PARTITION_TABLE_SCHEME=mbr
E: UDISKS_PRESENTATION_NOPOLICY=0
E: USEC_INITIALIZED=342063581

--14dae9340435a007cd04c610c3e9
Content-Type: application/x-gzip; name="insert-stick.log.gz"
Content-Disposition: attachment; filename="insert-stick.log.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h59xa6qd0

H4sICO7YFlAAA2luc2VydC1zdGljay5sb2cAzZ1Lb13Hkcf3/hR3mSx82VVdT63jVQazGGBmMwgC
WWQkwopkkJTz9af6SgPrHFE+N7G6/xEgUabM87vdp7se3fX4+/t390/vH07/uH/79vTzw/27p9PT
m7vTw92ru/tf7m5Pd7/cvXt6PP3t/cOL7/77Tz/8z+n7y79fvn36x5v7V29OH27vfjk93r27fTy9
//B0evm3p7uH08OHt3f1vPev7h4f79+9/u7PP/zXf/7wH59++qe7h3d3b08fLk/57tO//a9HWD9H
qlL85fTy9vZ0+XVTj7+vx9z8/Oq+1a8Xrd18+vqiyZluPjz+qDf6vZz+UH/74/5pTv1fetr4/YLO
7StP9eDf89SbN+8fn5hOf3h89Xj/5dOj9W/w9Jvx8L+Ov29wl+/88ePbPH1iJqt0/x2zvnuam/6u
+Xn+qeGp33DWd09P6zJ91j9703LORh7f5E0/vXx4fVd/eVH/3zOL6oIK+hZLdoO6+fjlN5hO05gf
J/r2/vGn3ce4fO/Lz5I8b/yfPsvlkV98mst3v/g83NQmf57Xd+/uHu5f3Ty+5k+f5dN3vvww1CdO
zo+Prz+blPqvL/maz+69X+4fnj68fHvz4+39Tbwgq5++/XKZsbdvIRe+9unfvn/1083j7Y8FH3/9
At+p5yz8c8LqwtT4JsLqOcGxQ4nos7P7lXez+2m1eSvra5Nj1uaJna8wg+XfSryE6eGOIhpT+NyO
KitsmnCi/99RD/S1HVUm0DdXi7/in5lM+u3JrE/0u4zIKz7Pr7K672X1bqUltX/JUpuhVJNl2meh
z/UGPas3qHWpVf7qzct3r+/WS35qQTkL/9w22a4E6m2eSXPVNtl/HpH2T8ic3U+L2r+NQUSqHisX
1m4uNHmi4fyMPbbjm34TT+v6fb3lMzWbvbJ/Q+Bu1wJLH8saJWS4luI0IXO8FNksJm7Lo9H3MnSX
bsQdXsIVh5fmDbj0hJw6EB/agfhySd1weGvRlxoXO3wXBy49Ex4aECX1zLTN8+kPJ9+tbDvc5LtF
A6oc90yg0I0IZyC+dv7Syd/is2QucPT58ewGgtdzaxyEWnoDL81Q777w1BW28Qa+9C0Qz11yqb7/
TOoNvNC8yT9QORd8j2nG1jX4XGvr7SbfHKZwC99bORpAPDVHHaMNvAQDpV5XESQ+FTn50oJRXs7A
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
--14dae9340435a007cd04c610c3e9--
