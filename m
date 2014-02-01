From: Albert Chen <Albert.Chen@wdc.com>
Subject: [LSF/MM TOPIC] SMR: Disrupting recording technology meriting a new
 class of storage device
Date: Sat, 1 Feb 2014 02:24:33 +0000
Message-ID: <DDA2008BD25F9046BFFC83788E83AF7E8167D4D0@wdscexmb03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, James Borden <James.Borden@wdc.com>, Jim Malina <Jim.Malina@wdc.com>, Curtis Stevens <curtis.stevens@wdc.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[LSF/MM TOPIC] SMR: Disrupting recording technology meriting a new class of storage device

Shingle Magnetic Recording is a disruptive technology that delivers the next areal density gain for the HDD industry by partially overlapping tracks. Shingling requires physical writes to be sequential, and opens the question of how to address this behavior at a system level. Two general approaches contemplated are to either to do the block management in the device or in the host storage stack/file system through Zone Block Commands (ZBC).

The use of ZBC to handle SMR block management yields several benefits such as:
- Predictable performance and latency
- Faster development time
- Access to application and system level semantic information
- Scalability / Fewer Drive Resources
- Higher reliability

Essential to a host managed approach (ZBC) is the openness of Linux and its community is a good place for WD to validate and seek feedback for our thinking - where in the Linux system stack is the best place to add ZBC handling? at the Device Mapper layer? or somewhere else in the storage stack? New ideas and comments are appreciated.

For more information about ZBC, please refer to Ted's <tytso@MIT.EDU> email to linux-fsdevel@vger.kernel.org with the subject " [RFC] Draft Linux kernel interfaces for ZBC drives".
