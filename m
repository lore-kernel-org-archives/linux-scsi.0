From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 15 Jan 2015 17:13:00 +0100
Message-ID: <54B7E70C.8020304@sandisk.com>
References: <54B63F74.2040702@sandisk.com>
 <20150115090829.GA14154@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150115090829.GA14154@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/15/15 10:08, Christoph Hellwig wrote:
> We're obviously not adding hooks for out of tree code to the kernel.

Hello Christoph,

My goal is to realize this proposal without adding hooks for out-of-tree
code in the upstream kernel. What I had in mind is to raise the
abstraction level of the API between LIO core and target drivers a
little bit (e.g. by using accessor functions where necessary instead of
accessing structure members directly) and to implement the translation
between this API and the SCST API in a translation header file.
#including that last header file should be sufficient to build a target
driver against the SCST core. Other changes might also be necessary,
e.g. general code cleanup, simplification or making the API between core
and target drivers more consistent.

Bart.
