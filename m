From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RESEND 00/35] qla2xxx: Patches for 3.18 scsi "misc"
	branch.
Date: Thu, 25 Sep 2014 19:01:29 +0200
Message-ID: <20140925170129.GA1336@lst.de>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: jbottomley@parallels.com, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks, I've applied both qla2xxx series to drivers-for-3.18.

I've noticed a lot of existing sparse endianess warnings
(from make C=2 CF="-D__CHECK_ENDIAN__" SUBDIRS=drivers/scsi/qla2xxx)
when compiling the driver, any chance you could try to fix those up
for 3.19?
