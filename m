From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 18:22:59 -0400
Message-ID: <43177F43.3000402@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave> <4317755C.5080700@adaptec.com> <431776A0.2030107@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <431776A0.2030107@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

On 09/01/05 17:46, Jeff Garzik wrote:
> This is the same reason a couple RAID drivers use the SCSI layer.  It 
> has nothing to do with SCSI-as-defined-by-T10, and more to do with the 

Do you think T10 has anything to offer Linux SCSI Core?

	Luben

> fact that SCSI provides a robust queueing/EH/block interface infrastructure.
