From: Christoph Lameter <cl@linux.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Date: Thu, 23 Jan 2014 14:54:37 -0600 (CST)
Message-ID: <alpine.DEB.2.10.1401231450550.8031@nuc>
References: <52DF353D.6050300@redhat.com> <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com> <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com> <20140122151913.GY4963@suse.de> <1390410233.1198.7.camel@ret.masoncoding.com>
 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com> <1390413819.1198.20.camel@ret.masoncoding.com> <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com> <20140123082734.GP13997@dastard>
 <1390492073.2372.118.camel@dabdike.int.hansenpartnership.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1390492073.2372.118.camel@dabdike.int.hansenpartnership.com>
Sender: owner-linux-mm@kvack.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <clm@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "mgorman@suse.de" <mgorman@suse.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 23 Jan 2014, James Bottomley wrote:

> If the compound page infrastructure exists today and is usable for this,
> what else do we need to do? ... because if it's a couple of trivial
> changes and a few minor patches to filesystems to take advantage of it,
> we might as well do it anyway.  I was only objecting on the grounds that
> the last time we looked at it, it was major VM surgery.  Can someone
> give a summary of how far we are away from being able to do this with
> the VM system today and what extra work is needed (and how big is this
> piece of work)?

The main problem for me was the page cache. The VM would not be such a
problem. Changing the page cache function required updates to many
filesystems.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
