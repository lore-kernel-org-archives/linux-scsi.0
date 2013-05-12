From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.9+ merge window
Date: Sun, 12 May 2013 19:21:48 +0200
Message-ID: <518FCFAC.8030306@redhat.com>
References: <1368226800.2024.32.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368226800.2024.32.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 11/05/2013 01:00, James Bottomley ha scritto:
> This is the final round of SCSI patches for the merge window.  It
> consists mostly of driver updates (bnx2fc, ibmfc, fnic, lpfc, be2iscsi,
> pm80xx, qla4x and ipr).  There's also the power management updates that
> complete the patches in Jens' tree, an iscsi refcounting problem fix
> from the last pull, some dif handling in scsi_debug fixes, a few nice
> code cleanups and an error handling busy bug fix.
> 

James,

can I have an answer about who is going to apply
http://thread.gmane.org/gmane.linux.kernel/1436904?  It is both a bugfix
and a minor security fix, has an Acked-by from Tejun, and has otherwise
been sitting there for almost three months.

Paolo
