From: MShetty <mranalini.shetty@patni.com>
Subject: Removable Hard Disk Drive
Date: Wed, 06 Nov 2002 19:29:36 +0530
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DC92048.423A58@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

With respect to a "removable hard disk drive" what would B128, B96,
B64 and B32 stand for ??

The piece of code I am reading doing a convertion between A and B
where
A =
     unsigned long   num_Major;
     unsigned long   num_Minor;
     unsigned int    num_Disk;
     unsigned int    num_Dkc;  // Disk Controller
     unsigned int    num_Dport;
     unsigned int    num_Hba;
     unsigned int    num_Hport; // Host Port
     unsigned int    num_Bus;
     unsigned int    num_TId;
     unsigned int    num_Hlu;  // Host Logical Unit

B =
struct B
{
    unsigned int B128;
    unsigned int B96;
    unsigned int B64;
    unsigned int B32;
};

Would help if I could get some clue on what they stand for.

Thanks and Regards,
M Shetty


