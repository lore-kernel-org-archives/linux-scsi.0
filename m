From: =?iso-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>
Subject: Re: Weird Qlogic 2200 FC HBA / CNSI G7324  problem
Date: Fri, 12 Jul 2002 02:45:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020712024511.A15943@stud.ntnu.no>
References: <20020712010844.A19115@stud.ntnu.no> <20020711164141.B8468@beaverton.ibm.com>
Reply-To: tlan@stud.ntnu.no
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020711164141.B8468@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Jul 11, 2002 at 04:41:41PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson:
> Can you send the output of "/proc/scsi/qla2200/1" and "/proc/scsi/qla2200/2" 

test3:~# cat /proc/scsi/qla2200/1
QLogic PCI to Fibre Channel Host Adapter for ISP22xx/ISP23xx:
        Firmware version:  2.02.03, Driver version 6.1b2
Entry address = f883a060
HBA: QLA2200 , Serial# B50409
Request Queue = 0x32d58000, Response Queue = 0x32d50000
Request Queue count= 128, Response Queue count= 64
Total number of active commands = 0
Total number of interrupts = 352
Total number of IOCBs (used/max) = (0/600)
Total number of queued commands = 0
    Device queue depth = 0x10
Number of free request entries = 116
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 3
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state= <READY>, flags= 0x8a0813
Dpc flags = 0x0
MBX flags = 0x0
SRB Free Count = 4096
Port down retry = 008


SCSI Device Information:
scsi-qla0-adapter-node=200000e08b02894b;
scsi-qla0-adapter-port=210000e08b02894b;
scsi-qla0-target-0=2000005013d01808;
scsi-qla0-target-1=2000005013d016d3;
scsi-qla0-target-2=2000005013d0158d;
scsi-qla0-target-3=2000005013d0154b;

SCSI LUN Information:
(Id:Lun)
( 0: 0): Total reqs 7, Pending reqs 0, flags 0x0, 0:0:82,
test3:~# cat /proc/scsi/qla2200/2
QLogic PCI to Fibre Channel Host Adapter for ISP22xx/ISP23xx:
        Firmware version:  2.02.03, Driver version 6.1b2
Entry address = f883a060
HBA: QLA2200 , Serial# B50405
Request Queue = 0x32d38000, Response Queue = 0x33060000
Request Queue count= 128, Response Queue count= 64
Total number of active commands = 0
Total number of interrupts = 10
Total number of IOCBs (used/max) = (0/600)
Total number of queued commands = 0
    Device queue depth = 0x10
Number of free request entries = 117
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 3
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state= <READY>, flags= 0x8a0813
Dpc flags = 0x0
MBX flags = 0x0
SRB Free Count = 4096
Port down retry = 008


SCSI Device Information:
scsi-qla1-adapter-node=200000e08b02854b;
scsi-qla1-adapter-port=210000e08b02854b;
scsi-qla1-target-0=2000005013d01808;
scsi-qla1-target-1=2000005013d016d3;
scsi-qla1-target-2=2000005013d0158d;
scsi-qla1-target-3=2000005013d0154b;

SCSI LUN Information:
(Id:Lun)
( 2: 0): Total reqs 7, Pending reqs 0, flags 0x0, 1:0:86,



-- 
Thomas
