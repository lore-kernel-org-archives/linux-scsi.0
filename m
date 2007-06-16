From: Hari Hara Kumar M <hari@xsigo.com>
Subject: need help with kmap_atomic() behavior
Date: Sat, 16 Jun 2007 14:52:21 -0700
Message-ID: <1182030741.26268.59.camel@hmaharaj-ws.xsigo.com>
References: <20070501180113.20160.77978.sendpatchset@thinktank.campus.ltu.se>
	 <Pine.LNX.4.64.0705011415070.13459@localhost.localdomain>
	 <1178044924.4320.29.camel@mulgrave.il.steeleye.com>
	 <463796B1.9060706@student.ltu.se>
Reply-To: hari@xsigo.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757419AbXFPVwc@vger.kernel.org>
In-Reply-To: <463796B1.9060706@student.ltu.se>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello

We are mapping struct page ptrs from scattergather list entries using
kmap_atomic(page_ptr, KM_USER0) to get the virtual address for doing a
copy to work around some alignment restrictions in our driver.

If the first entry in the scatterlist has length > 4k (say 11k) and has
an offset of 1k then, will kmap of the struct page ptr in this
scattergather entry map all of the relevant pages (3 in this case for
11k) needed to cover this sg entry?

Thanks in advance.
-Hari
