From: Jes Sorensen <jes@sgi.com>
Subject: Re: [PATCH 0/2] Fix RAID5 + IA64 compile
Date: 31 Jul 2006 05:22:38 -0400
Message-ID: <yq01ws29li9.fsf@jaguar.mkp.net>
References: <20060728140145.9149.43458.sendpatchset@prarit.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20060728140145.9149.43458.sendpatchset@prarit.boston.redhat.com>
Sender: linux-ia64-owner@vger.kernel.org
To: Prarit Bhargava <prarit@sgi.com>
Cc: linux-ia64@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Prarit" == Prarit Bhargava <prarit@sgi.com> writes:

Prarit> Patchset to fix RAID5 on ia64.  Removes dead CONFIG options
Prarit> and introduces a new CONFIG option.

Prarit,

Looking through that patch, why introduce a new CONFIG_ option when it
can all be deducted from CONFIG_MDRAID456 and CONFIG_ia64?

Cheers,
Jes
