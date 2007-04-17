From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/4] libata: implement libata.spindown_compat
Date: Tue, 17 Apr 2007 11:20:56 -0400
Message-ID: <4624E5D8.6080806@garzik.org>
References: <20070320150718.GF6152@htj.dyndns.org>	 <20070320151359.GG6152@htj.dyndns.org>	 <20070320152533.GH6152@htj.dyndns.org>	 <20070320155548.GI6152@htj.dyndns.org>  <4624DD95.3070608@garzik.org> <1176822118.3671.32.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1176822118.3671.32.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-04-17 at 10:45 -0400, Jeff Garzik wrote:
>> ACK patches 3-4 for upstream.  I'm dropping them, and requesting resend 
>> when patches 1-2 are applied (which I also ACK).  Or, alternately, I 
>> could apply all four patches with the other subsystem owner's assent, or 
>> the other subsystem owner could apply all four patches now that I have 
>> ACK'd them.  Pick any of the three options. :)
> 
> I've got 1 and 2 upstream to -mm via scsi-misc-2.6 already.
> Unfortunately they're not simply separable since there's a bad
> interaction with the sd messages rework that's also in scsi-misc.

then, unless there are dependencies in libata-dev, how about Tejun 
pushes patches 3-4 through scsi-misc as well?


