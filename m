From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: 04 Sep 2002 00:28:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1031095727.21439.47.camel@irongate.swansea.linux.org.uk>
References: <alan@lxorguk.ukuu.org.uk>
	<200209032132.g83LWdD09043@localhost.localdomain>
	<20020903185036.G12201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020903185036.G12201@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2002-09-03 at 23:50, Doug Ledford wrote:
> Hmmm...I thought a big reason for adding REQ_BARRIER was to be able to 
> support more robust journaling with order requirement verification.  If 
> that's true, then REQ_BARRIER commands could become quite common on disks 
> using ext3.

I doubt it very much because the only way to implement barriers on IDE
is fantastically expensive. I'm dubious it makes sense for ext3 to use
barriers in that way. All it needs as I understand the rules is that an
I/O isnt reported as completed by the device driver before it is on the
medium or in a non volatile cache.


