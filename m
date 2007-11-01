From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] debloat aic7xxx and aic79xx drivers
Date: Thu, 1 Nov 2007 16:15:02 -0600
Message-ID: <20071101221502.GA19914@parisc-linux.org>
References: <200710141558.27156.vda.linux@googlemail.com> <200710141600.10468.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755144AbXKAWP0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200710141600.10468.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 14, 2007 at 04:00:10PM +0100, Denys Vlasenko wrote:
> Deinlines and moves big functions from .h to .c files.
> Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.

Adds trailing whitespace.
.dotest/patch:216:       * We also set the full residual flag which the 
Adds trailing whitespace.
.dotest/patch:2383:{       
warning: 2 lines add trailing whitespaces.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
