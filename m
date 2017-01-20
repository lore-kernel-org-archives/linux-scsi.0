From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/4] mpt3sas: Added print to notify cable running at
 a degraded speed.
Date: Fri, 20 Jan 2017 10:11:37 -0800
Message-ID: <1484935897.12563.6.camel@perches.com>
References: <1484923333-8509-1-git-send-email-chaitra.basappa@broadcom.com>
         <1484923333-8509-2-git-send-email-chaitra.basappa@broadcom.com>
         <1484934914.12563.4.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484934914.12563.4.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, jejb@kernel.org, hch@infradead.org, James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-20 at 09:55 -0800, Joe Perches wrote:
> I believe MPT3SAS_FMT is unnecessary obfuscation and
> it should just be replaced by "%s: " everywhere.

Here's a trivial command that could be used one day:

$ git grep --name-only MPT3SAS_FMT -- "*.c" | \
  xargs perl -p -i -e 'local $/; while (<>) { s/\bMPT3SAS_FMT\s*"/"%s: /g; print; }'
