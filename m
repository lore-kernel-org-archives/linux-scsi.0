From: Greg KH <greg@kroah.com>
Subject: Re: PROBLEM: syzkaller found / pool corruption-overwrite / page in
 user-area or NULL
Date: Thu, 10 Jan 2019 20:27:36 +0100
Message-ID: <20190110192736.GA27348@kroah.com>
References: <FTiTvUZRA5yMupEMxO6bakUBM0kgENu3iSyKzomSMpfDWnMJ-AQbx4X3GRTNzNE2ZxaMAEU3nfYARed4mpJV-xC6lBR6PR5hsWKwbvAs5II=@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FTiTvUZRA5yMupEMxO6bakUBM0kgENu3iSyKzomSMpfDWnMJ-AQbx4X3GRTNzNE2ZxaMAEU3nfYARed4mpJV-xC6lBR6PR5hsWKwbvAs5II=@protonmail.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: esploit <esploit@protonmail.ch>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2019 at 07:05:26PM +0000, esploit wrote:
> Hi, I've been getting more into Kernel stuff lately and forged ahead
> with some syzkaller bug finding.

for syzkaller stuff, no need to cc: the security mailing list.  Just
work with the respective subsystem maintainers and developers (like you
properly cc:ed) and all should be fine.

thanks!

greg k-h
