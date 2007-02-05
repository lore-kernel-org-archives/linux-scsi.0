From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Mon, 05 Feb 2007 08:55:10 -0600
Message-ID: <1170687310.3387.2.camel@mulgrave.il.steeleye.com>
References: <20070119170122.GS10987@htj.dyndns.org>
	 <45B1574D.1090502@us.ibm.com>  <45B18AE2.3010503@gmail.com>
	 <1169303969.2842.10.camel@mulgrave.il.steeleye.com>
	 <45C6FC45.4050603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C6FC45.4050603@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-02-05 at 18:43 +0900, Tejun Heo wrote:
> James, do you think such change to sd is acceptable?  As the original
> patch, the default behavior won't be changed, so unless specifically
> configured (probably during boot by dist) there won't be any behavior
> change.

Yes, as long as the default is off and it's configurable per disk, I
think the power management software can find the root disks and adjust
the settings if necessary.

James


