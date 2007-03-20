From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/4] libata: reimplement suspend/resume support using
 sdev->manage_start_stop
Date: Tue, 20 Mar 2007 16:39:19 +0000
Message-ID: <20070320163919.222ae79d@lxorguk.ukuu.org.uk>
References: <20070320150718.GF6152@htj.dyndns.org>
	<20070320151359.GG6152@htj.dyndns.org>
	<20070320152533.GH6152@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070320152533.GH6152@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

> * DPM is dropped.  This also simplifies code a lot.  Suspend/resume
>   status is port-wide now.

Makes sense

> * sdev->manage_start_stop is set to 1 in ata_scsi_slave_config().
>   This fixes spindown on shutdown and suspend-to-disk.

Yay!!!!
 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>

