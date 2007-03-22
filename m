From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Thu, 22 Mar 2007 09:29:40 -0300
Message-ID: <20070322122940.GA29824@khazad-dum.debian.net>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <460020DF.6090203@torque.net> <460099DD.2050706@gmail.com> <460258BD.9080606@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <460258BD.9080606@vlnb.net>
Sender: linux-ide-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Tejun Heo <htejun@gmail.com>, dougg@torque.net, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 22 Mar 2007, Vladislav Bolkhovitin wrote:
> Seems, there is another way of doing a bank spin up / spin down: doing 
> it in two passes. On the first pass START_STOP will be issued with 
> IMMED=1 on all devices, then on the second pass START_STOP will be 
> issued with IMMED=0. So the devices will spin up / spin down in the 
> parallel, but synchronously, hence the needed result will be achieved 

And maybe trip the PSU's overcurrent defenses?  There is a reason to default
to sequential spin-up for disks...  Of course, it can be user-selectable.
But should it be the default?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
