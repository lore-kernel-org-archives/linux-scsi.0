From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: Wed, 18 Aug 2010 16:36:01 +0200
Message-ID: <4C6BEFD1.8010200@gmail.com>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>	 <20100817223145.GC4641@Krystal>  <4C6BC72E.6040607@gmail.com> <1282141930.3035.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282141930.3035.9.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/18/2010 04:32 PM, James Bottomley wrote:
>> James and Jens, could you take the two remaining (SCSI and BLOCK)?
> 
> Sure ... could you identify the email by subject, please? lkml.org seems
> to be down this morning.

Sure:
[PATCH v2] BLOCK: fix bio.bi_rw handling
and
[PATCH v2] SCSI: fix bio.bi_rw handling

You should have received one copy to your suse.de inbox, if everything
worked.

thanks,
-- 
js
