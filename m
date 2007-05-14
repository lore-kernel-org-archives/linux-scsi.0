From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6] SCSI: kill sht->suspend/resume
Date: Mon, 14 May 2007 17:52:46 +0200
Message-ID: <464885CE.5070404@gmail.com>
References: <20070320150718.GF6152@htj.dyndns.org>	 <20070320151359.GG6152@htj.dyndns.org>	 <20070320152533.GH6152@htj.dyndns.org>	 <20070320152919.GA28403@infradead.org>	 <20070321070516.GJ6152@htj.dyndns.org> <1174490184.3618.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1174490184.3618.11.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-03-21 at 16:05 +0900, Tejun Heo wrote:
>> This patch breaks the existing libata suspend/resume support and thus
>> should not be applied before libata is updated.  So, please don't
>> apply it yet.
> 
> I don't have a git tree for this, but I'll  mark it in my email, just
> say the word.

It took quite some while but libata is updated now and this patch can go in.

Thanks.

-- 
tejun
