From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: Addressing when lun spans disks
Date: Mon, 21 Oct 2002 10:24:01 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OFB46BE7A7.F65C418B-ON87256C59.005F090F@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


>What exactly is the value of 'target id' when my lun spans multiple
>disks ?? I am not able to understand how the physical disk address would
>be obtained when a lun spans multiple disks

Do you understand that a target is bigger than a logical unit?  A physical
unit has a target ID and is subdvided into logical units which have logical
unit numbers.  The logical unit number identifies a logical unit within a
physical unit.

There is no such thing as a logical unit that spans physical units.

In some advanced storage subsystems, the physical subsystem contains a
whole bunch of disks and space on those disks is allocated arbitrarily to
logical units.  In that case, the whole subsystem is the physical unit and
has one target ID.  And there is no SCSI identifier that identifies the
individual disks -- they are invisible to the SCSI protocol.



