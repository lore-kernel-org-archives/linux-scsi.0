From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Thu, 22 Mar 2007 18:14:44 +0300
Message-ID: <46029D64.6040206@vlnb.net>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <460020DF.6090203@torque.net> <460099DD.2050706@gmail.com> <460258BD.9080606@vlnb.net> <20070322122940.GA29824@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070322122940.GA29824@khazad-dum.debian.net>
Sender: linux-ide-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tejun Heo <htejun@gmail.com>, dougg@torque.net, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 22 Mar 2007, Vladislav Bolkhovitin wrote:
> 
>>Seems, there is another way of doing a bank spin up / spin down: doing 
>>it in two passes. On the first pass START_STOP will be issued with 
>>IMMED=1 on all devices, then on the second pass START_STOP will be 
>>issued with IMMED=0. So the devices will spin up / spin down in the 
>>parallel, but synchronously, hence the needed result will be achieved 
> 
> 
> And maybe trip the PSU's overcurrent defenses?  There is a reason to default
> to sequential spin-up for disks... 

But on spin down there is no such problem

> Of course, it can be user-selectable. But should it be the default?
> 

