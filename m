From: Ondrej Zary <linux@zary.sk>
Subject: Re: [RFC PATCH 1/4] fdomain: Resurrect driver (core)
Date: Sun, 28 Apr 2019 21:52:31 +0200
Message-ID: <201904282152.32077.linux@zary.sk>
References: <20190422173323.15365-1-linux@zary.sk> <20190422173323.15365-2-linux@zary.sk> <20190424060212.GA5506@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424060212.GA5506@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 24 April 2019 08:02:12 Christoph Hellwig wrote:
> > +static void fdomain_work(struct work_struct *work)
> > +{
> > +	struct fdomain *fd = container_of(work, struct fdomain, work);
> > +	struct Scsi_Host *sh = container_of((void *)fd, struct Scsi_Host,
> > +					    hostdata);
> 
> This looks odd.  We should never need a void cast for container_of.

This cast is present in all drivers involving container_of, struct Scsi_Host and hostdata. hostdata in struct Scsi_Host is defined as "unsigned long hostdata[0]"...

-- 
Ondrej Zary
