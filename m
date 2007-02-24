From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: end to end error recovery musings
Date: Fri, 23 Feb 2007 18:05:56 -0800
Message-ID: <45DF9D84.7000205@zytor.com>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com> <20070224003723.GS10715@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070224003723.GS10715@schatzie.adilger.int>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

Andreas Dilger wrote:
> And clearing this list when the sector is overwritten, as it will almost
> certainly be relocated at the disk level.

Certainly if the overwrite is successful.

	-hpa
