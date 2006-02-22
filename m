From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: lsscsi-0.17 released
Date: Wed, 22 Feb 2006 19:00:15 +0100
Message-ID: <20060222180015.GB20880@merlin.emma.line.org>
References: <43FBA4CD.6000505@torque.net> <m34q2r93q2.fsf@merlin.emma.line.org> <43FC7CCB.4090508@torque.net> <20060222160602.GB17473@merlin.emma.line.org> <43FC90E4.10805@torque.net> <20060222163426.GG28587@parisc-linux.org> <20060222171438.GA20272@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:28825 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1161219AbWBVSAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 13:00:21 -0500
Content-Disposition: inline
In-Reply-To: <20060222171438.GA20272@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Douglas Gilbert <dougg@torque.net>, Matthias Andree <matthias.andree@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 22 Feb 2006, Greg KH wrote:

> It was changed as there would be more than one "block" symlink in a
> device's directory if more than one block device was attached to a
> single struct device.  For example, ub and multi-lun devices (there were
> other reports of this happening for scsi devices too at the time from
> what I remember.)

OK, just post an announcement to l-k when sysfs has stabilized enough to
be worth bothering.

-- 
Matthias Andree
