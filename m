From: Ricky Beam <jfbeam@bluetronic.net>
Subject: RE: qla2xxx (2100) vs. qlogicfc [again]
Date: Fri, 7 May 2004 19:55:13 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405071936110.14297-100000@sweetums.bluetronic.net>
References: <B179AE41C1147041AA1121F44614F0B060EE83@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:58620 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S263893AbUEGX7s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 19:59:48 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EE83@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>

On Thu, 6 May 2004, Andrew Vasquez wrote:
>I have a batch of patches pending for submission that I'll have a
>chance to get to tonight.  In the interim, could you download this
>driver:
...
>Enable some select debug settings:
>
>        o DEBUG_QLA2100 set to 1 in qla_settings.h
>
>        o QL_DEBUG_LEVEL_2 defined in qla_dbg.h
>
>Recompile, reload the driver, and forward over the relevant snippets
>from var/log/messages.

May  7 18:24:57
%%% card - hub - switch - two shelves
QLogic Fibre Channel HBA Driver (f8a0c000)
qla2100 0000:06:03.0: Found an ISP2100, irq 24, iobase 0xf8926000
qla2100 0000:06:03.0: Configuring PCI space...
qla2100 0000:06:03.0: Configure NVRAM parameters...
qla2100 0000:06:03.0: Verifying loaded RISC code...
scsi(0): **** Load RISC code ****
scsi(0): Verifying Checksum of loaded RISC code.
scsi(0): Checksum OK, start firmware.
scsi(0): Issue init firmware.
qla2100 0000:06:03.0: Waiting for LIP to complete...
qla2100 0000:06:03.0: Cable is unplugged...
scsi(0): fw_state=4 curr time=15d7fa.
scsi(0): Firmware ready **** FAILED ****.
qla2x00_initialize_adapter(): **** FAILED ****
DEBUG: detect hba 0 at address = f5e681e0
scsi0 : qla2xxx
qla2100 0000:06:03.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b12-k-debug
  QLogic QLA2100 -
  ISP2100: PCI (33 MHz) @ 0000:06:03.0 hdma-, host#=0, fw=0.00.00 (0)

May  7 18:26:13 master kernel: scsi(0): Asynchronous LIP RESET (f7f7).
May  7 18:26:13 master kernel: qla2100 0000:06:03.0: LIP reset occured (f7f7).
May  7 18:26:13 master kernel: scsi(0): qla2x00_reset_marker()
May  7 18:26:16 master kernel: scsi(0): LIP occured (f7f7).
May  7 18:26:16 master kernel: qla2100 0000:06:03.0: LIP occured (f7f7).
May  7 18:26:17 master kernel: scsi(0): Asynchronous LIP RESET (f7f7).
May  7 18:26:17 master kernel: qla2100 0000:06:03.0: LIP reset occured (f7f7).
May  7 18:26:17 master kernel: scsi(0): qla2x00_reset_marker()
May  7 18:26:17 master kernel: scsi(0): LIP occured (f7f7).
May  7 18:26:17 master kernel: qla2100 0000:06:03.0: LIP occured (f7f7).
May  7 18:26:53 master kernel: scsi(0): DPC handler exiting

May  7 18:27:32
%%% card - switch - two shelves
QLogic Fibre Channel HBA Driver (f8a0c000)
qla2100 0000:06:03.0: Found an ISP2100, irq 24, iobase 0xf8930000
qla2100 0000:06:03.0: Configuring PCI space...
qla2100 0000:06:03.0: Configure NVRAM parameters...
qla2100 0000:06:03.0: Verifying loaded RISC code...
scsi(0): **** Load RISC code ****
scsi(0): Verifying Checksum of loaded RISC code.
scsi(0): Checksum OK, start firmware.
scsi(0): Issue init firmware.
scsi(0): Asynchronous LIP RESET (f8f7).
qla2100 0000:06:03.0: LIP reset occured (f8f7).
qla2100 0000:06:03.0: Waiting for LIP to complete...
scsi(0): LIP occured (f8f7).
qla2100 0000:06:03.0: LIP occured (f8f7).
scsi(0): Asynchronous LIP RESET (f7f7).
qla2100 0000:06:03.0: LIP reset occured (f7f7).
scsi(0): LIP occured (f7f7).
qla2100 0000:06:03.0: LIP occured (f7f7).
--- (tired of waiting... physically disconnect cable @ 18:31:25)
--- (note: switch reports zero frames on all ports during this delay)
qla2100 0000:06:03.0: Cable is unplugged...
scsi(0): fw_state=4 curr time=1b767c.
scsi(0): Firmware ready **** FAILED ****.
qla2x00_initialize_adapter(): **** FAILED ****
DEBUG: detect hba 0 at address = f5e681e0
scsi0 : qla2xxx
qla2100 0000:06:03.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b12-k-debug
  QLogic QLA2100 -
  ISP2100: PCI (33 MHz) @ 0000:06:03.0 hdma-, host#=0, fw=0.00.00 (0)

May  7 18:31:28 master kernel: scsi(0): Asynchronous LIP RESET (f8f7).
May  7 18:31:28 master kernel: qla2100 0000:06:03.0: LIP reset occured (f8f7).
May  7 18:31:28 master kernel: scsi(0): qla2x00_reset_marker()
May  7 18:31:28 master kernel: scsi(0): LIP occured (f8f7).
May  7 18:31:28 master kernel: qla2100 0000:06:03.0: LIP occured (f8f7).
May  7 18:31:29 master kernel: scsi(0): Asynchronous LIP RESET (f7f7).
May  7 18:31:29 master kernel: qla2100 0000:06:03.0: LIP reset occured (f7f7).
May  7 18:31:29 master kernel: scsi(0): qla2x00_reset_marker()
May  7 18:31:29 master kernel: scsi(0): LIP occured (f7f7).
May  7 18:31:29 master kernel: qla2100 0000:06:03.0: LIP occured (f7f7).
May  7 18:31:47 master kernel: scsi(0): DPC handler exiting


May  7 18:34:42
%%% card - hub - two shelves
QLogic Fibre Channel HBA Driver (f8a0c000)
qla2100 0000:06:03.0: Found an ISP2100, irq 24, iobase 0xf898d000
qla2100 0000:06:03.0: Configuring PCI space...
qla2100 0000:06:03.0: Configure NVRAM parameters...
qla2100 0000:06:03.0: Verifying loaded RISC code...
scsi(0): **** Load RISC code ****
scsi(0): Verifying Checksum of loaded RISC code.
scsi(0): Checksum OK, start firmware.
scsi(0): Issue init firmware.
qla2100 0000:06:03.0: Waiting for LIP to complete...
scsi(0): Asynchronous LIP RESET (f8f7).
qla2100 0000:06:03.0: LIP reset occured (f8f7).
scsi(0): LIP occured (f8f7).
qla2100 0000:06:03.0: LIP occured (f8f7).
scsi(0): Asynchronous LOOP UP (1 Gbps).
qla2100 0000:06:03.0: LOOP UP detected (1 Gbps).
scsi(0): Asynchronous PORT UPDATE.
scsi(0): Port database changed f8f7 0000.
scsi(0): F/W Ready - OK
scsi(0): fw_state=3 curr time=1e7ff2.
qla2100 0000:06:03.0: Topology - (Loop), Host Loop address 0x7
scsi(0): Configure loop -- dpc flags =0x80040
scsi(0): RLC failed to issue iocb! fcport=[0000/f5f4fa90] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0000/f5f4fa90] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0000 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0000 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0000 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0000 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0000 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0000 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0000 lun=7 type=7f
scsi(0): RLC failed to issue iocb! fcport=[0001/f5f4f810] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0001/f5f4f810] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0001 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0001 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0001 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0001 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0001 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0001 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0001 lun=7 type=7f
scsi(0): RLC failed to issue iocb! fcport=[0002/f5f4fb10] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0002/f5f4fb10] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0002 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0002 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0002 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0002 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0002 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0002 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0002 lun=7 type=7f
scsi(0): RLC failed to issue iocb! fcport=[0003/f5f4f290] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0003/f5f4f290] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0003 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0003 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0003 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0003 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0003 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0003 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0003 lun=7 type=7f
scsi(0): RLC failed to issue iocb! fcport=[0004/f5f70f10] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0004/f5f70f10] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0004 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0004 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0004 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0004 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0004 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0004 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0004 lun=7 type=7f
scsi(0): RLC failed to issue iocb! fcport=[0005/f5f70e90] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0005/f5f70e90] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0005 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0005 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0005 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0005 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0005 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0005 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0005 lun=7 type=7f
scsi(0): RLC failed to issue iocb! fcport=[0006/f5f70e10] rval=0 cs=0 ss=b02
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 06 00 00 00 00 0a
scsi(0): RLC failed to issue iocb! fcport=[0006/f5f70e10] rval=0 cs=0 ss=302
scsi(0): RLC SS_CHECK_CONDITION Sense Data 70 00 05 00 00 00 00 0a
scsi(0): Unsupported lun type -- loop id=0x0006 lun=1 type=7f
scsi(0): Unsupported lun type -- loop id=0x0006 lun=2 type=7f
scsi(0): Unsupported lun type -- loop id=0x0006 lun=3 type=7f
scsi(0): Unsupported lun type -- loop id=0x0006 lun=4 type=7f
scsi(0): Unsupported lun type -- loop id=0x0006 lun=5 type=7f
scsi(0): Unsupported lun type -- loop id=0x0006 lun=6 type=7f
scsi(0): Unsupported lun type -- loop id=0x0006 lun=7 type=7f
qla2x00_mailbox_command(0): **** FAILED. mbx0=4006, mbx1=7e, mbx2=a6d2, cmd=6a ****
qla2x00_get_port_name(0): failed=102.
scsi(0): MBC_GET_PORT_NAME Failed, No FL Port
scsi(0): Alloc Target 0 @ f7719800
scsi(0): Assigning target ID=00 @ f7719800 to loop id=0x0000, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 0.
scsi(0): Alloc Target 1 @ f7719000
scsi(0): Assigning target ID=01 @ f7719000 to loop id=0x0001, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 1.
scsi(0): Alloc Target 2 @ f5fc6800
scsi(0): Assigning target ID=02 @ f5fc6800 to loop id=0x0002, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 2.
scsi(0): Alloc Target 3 @ f5fc6000
scsi(0): Assigning target ID=03 @ f5fc6000 to loop id=0x0003, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 3.
scsi(0): Alloc Target 4 @ f7077800
scsi(0): Assigning target ID=04 @ f7077800 to loop id=0x0004, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 4.
scsi(0): Alloc Target 5 @ f7077000
scsi(0): Assigning target ID=05 @ f7077000 to loop id=0x0005, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 5.
scsi(0): Alloc Target 6 @ f7570800
scsi(0): Assigning target ID=06 @ f7570800 to loop id=0x0006, port state=0x4, port down retry=60
scsi(0): Alloc Lun 0 @ tgt 6.
scsi(0): LOOP READY
DEBUG: detect hba 0 at address = f5e681e0
scsi0 : qla2xxx
qla2100 0000:06:03.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b12-k-debug
  QLogic QLA2100 -
  ISP2100: PCI (33 MHz) @ 0000:06:03.0 hdma-, host#=0, fw=1.19.24 TP
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:0:0): Enabled tagged queuing, queue depth 16.
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:1:0): Enabled tagged queuing, queue depth 16.
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:2:0): Enabled tagged queuing, queue depth 16.
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:3:0): Enabled tagged queuing, queue depth 16.
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:4:0): Enabled tagged queuing, queue depth 16.
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:5:0): Enabled tagged queuing, queue depth 16.
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
qla2100 0000:06:03.0: scsi(0:0:6:0): Enabled tagged queuing, queue depth 16.

Using qlogicfc...
May  7 19:03:35
%%% card - hub - switch - two shelves
qlogicfc0 : Loop Reinitialized
qlogicfc0 : link is not up
scsi0 : QLogic ISP2100 SCSI on PCI bus 06 device 18 irq 24 base 0xd800
--- (@ 19:04:52)
qlogicfc0 : Loop Reinitialized
qlogicfc0 : Link is Up
qlogicfc0 : Port Database
wwn: 200000e08b014419  scsi_id: 0  loop_id: 7
wwn: 2100002037322a58  scsi_id: 1  loop_id: 0
wwn: 210000203732c427  scsi_id: 2  loop_id: 1
wwn: 210000203732bf6a  scsi_id: 3  loop_id: 2
wwn: 210000203732867e  scsi_id: 4  loop_id: 3
wwn: 2100002037329a24  scsi_id: 5  loop_id: 4
wwn: 210000203732c135  scsi_id: 6  loop_id: 5
wwn: 210000203732b1b0  scsi_id: 7  loop_id: 6
wwn: 21000020371205da  scsi_id: 8  loop_id: 8
wwn: 210000203732bee5  scsi_id: 9  loop_id: 9
wwn: 2100002037324c48  scsi_id: a  loop_id: a
wwn: 210000203732b31a  scsi_id: b  loop_id: b
wwn: 210000203732c03c  scsi_id: c  loop_id: c
wwn: 210000203732bfca  scsi_id: d  loop_id: d
wwn: 210000203732c10a  scsi_id: e  loop_id: e

At which point the drives are usable.

--Ricky


