From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Wed, 21 Mar 2007 12:42:11 +0900
Message-ID: <4600A993.90801@gmail.com>
References: <20070320150718.GF6152@htj.dyndns.org>	 <20070320151359.GG6152@htj.dyndns.org>	 <1174409899.3522.16.camel@mulgrave.il.steeleye.com>	 <460014FB.1050703@gmail.com> <1174411563.3522.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1174411563.3522.22.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-03-21 at 02:08 +0900, Tejun Heo wrote:
>> I got too comfortable with libata-dev#upstream and forgot to verify
>> patches against scsi-misc-2.6.  Sorry about that.  If you don't have
>> objection against the content, I'll resubmit the SCSI part against
>> scsi-misc-2.6.  Once it's in scsi-misc-2.6, we can pull it into
>> libata-dev#upstream and do the libata part there.  As the SCSI change
>> doesn't break libata, they can be done separately.
> 
> I should already have it in scsi-misc-2.6 ... you could verify I got the
> merge right ...
> 
> There'll be an additional piece to put the new sd_printk helpers into
> the routines, which I attach below.

Yeap, everything looks fine.  Thanks.

-- 
tejun
