From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Temporary location for some of the SCSI trees
Date: Thu, 15 Sep 2011 10:37:33 -0500
Message-ID: <1316101053.2983.42.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I've relocated the scsi-rc-fixes and scsi-misc trees on to my own
infrastructure while master.kernel.org is down.  The locations are:

git://bedivere.hansenpartnership.com/git/scsi-rc-fixes-2.6.git
git://bedivere.hansenpartnership.com/git/scsi-misc-2.6.git

Since we're not currently using the scsi-postmerge tree, I haven't yet
done a replacement for it.

The current tree tops are

scsi-misc:

  linus      ba8f318 m68k: fix __page_to_pfn for a const struct page argument
  master     ebd1f64 [SCSI] scsi_dh_alua: Decrease retry interval
  merge-base 7ca3c80 [SCSI] qla2xxx: Update version number to 8.03.07.07-k.

scsi-fixes:

  linus  003f6c9 lib/sha1.c: quiet sparse noise about symbol not declared
  master 610602f [SCSI] bnx2i: Fixed the endian on TTT for NOP out transmission

Could you add these to linux-next, please (until master comes back at least)?

For SCSI people, I still don't have any machinery for notifications or
an ftp site for the combined patch sets and change logs yet.  When I get
that sorted out, I'll begin adding commits again.

Thanks,

James
