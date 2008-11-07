From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 16:28:11 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0811071625280.2199@Nokia-N800-26>
References: <4913028B.6010405@redhat.com>  <1225984628.4703.80.camel@localhost.localdomain>
  <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>  <20081107120534.GO21867@kernel.dk>
  <1226072970.15281.46.camel@think.oraclecorp.com>  <yq1r65na5ll.fsf@sermon.lab.mkp.net>
  <1226074002.8030.33.camel@localhost.localdomain>
 <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain>
 <49146B63.70208@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49146B63.70208@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Chris Mason <chris.mason@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 Nov 2008, Ric Wheeler wrote:

> Depending on how vendors implement those unmap commands, sending down a 
> sequence of commands might cause a performance issue if done at too fine a 
> granularity. Easiest way to handle that is to make sure that we have a way of 
> disabling the unmap/discard support (mount option?).

Or maybe a per-queue option, since it already is.

-- 
dwmw2
