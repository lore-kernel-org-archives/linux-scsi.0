From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/4] libata: implement libata.spindown_compat
Date: Tue, 17 Apr 2007 12:33:42 -0500
Message-ID: <1176831223.3671.41.camel@mulgrave.il.steeleye.com>
References: <20070320150718.GF6152@htj.dyndns.org>
	 <20070320151359.GG6152@htj.dyndns.org>
	 <20070320152533.GH6152@htj.dyndns.org>
	 <20070320155548.GI6152@htj.dyndns.org>  <4624DD95.3070608@garzik.org>
	 <1176822118.3671.32.camel@mulgrave.il.steeleye.com>
	 <4624E5D8.6080806@garzik.org>
	 <1176823590.3671.35.camel@mulgrave.il.steeleye.com>
	 <4624FF5B.9010000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4624FF5B.9010000@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-04-18 at 02:09 +0900, Tejun Heo wrote:
> James, are you going to rebase scsi-misc-2.6 before sending to Linus
> when 2.6.22-rc1 window opens?  If not, Jeff can pull it into libata-dev
> and patch 3 and 4 can go in there.  The difference in libata between
> scsi-misc-2.6 and libata-dev is rather large and applying 3 and 4 to
> scsi-misc-2.6 would cause merging headache later.

No ... I try never to rebase a for-linus tree ... it just causes more
hassle than it's worth.

James


