From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: ide-scsi with ide-hd?
Date: Sat, 7 Dec 2002 10:37:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10212071036340.397-100000@master.linux-ide.org>
References: <1039179795.22971.1.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1039179795.22971.1.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Soddemann <Thomas.Soddemann@rzg.mpg.de>, linux-scsi@vger.kernel.org


Yes they do, but only ones with special firmware.

IE Tivo modified drives.

On 6 Dec 2002, Alan Cox wrote:

> On Fri, 2002-12-06 at 09:16, Thomas Soddemann wrote:
> > Hi,
> > 
> > does anybody know whether there is there a possibility to use ide-scsi 
> > in connection with an IDE HD?
> 
> Basically no - IDE disks don't support ATAPI.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Andre Hedrick
LAD Storage Consulting Group

