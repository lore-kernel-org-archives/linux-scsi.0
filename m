From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 11:49:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025184958.GB1514@beaverton.ibm.com>
References: <James.Bottomley@steeleye.com> <200210251416.g9PEGxv01952@localhost.localdomain> <200210251834.g9PIY2l03794@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210251834.g9PIY2l03794@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

This looks better than my quick hack. I talked to Badari about putting a
printk on the status check of scsi_delete_timer.

-andmike
--
Michael Anderson
andmike@us.ibm.com

