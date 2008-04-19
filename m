From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 17:19:34 +0200
Message-ID: <20080419151934.GA17089@elte.hu>
References: <1208540517.3063.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762059AbYDSPT7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1208540517.3063.18.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

>       libsas: Provide a transport-level facility to request SAS addrs

this (or a nearby) commit caused a build regression:

 drivers/built-in.o: In function `sas_request_addr':
 : undefined reference to `request_firmware'
 drivers/built-in.o: In function `sas_request_addr':
 : undefined reference to `release_firmware'

config can be found at:

   http://redhat.com/~mingo/misc/config-Sat_Apr_19_16_58_35_CEST_2008.bad

... brought to you by x86.git's randconfig build and boot service ;-)

	Ingo
