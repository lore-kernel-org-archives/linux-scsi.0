From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ide-scsi with ide-hd?
Date: 06 Dec 2002 13:03:15 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1039179795.22971.1.camel@irongate.swansea.linux.org.uk>
References: <3DF06AD0.5070507@rzg.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DF06AD0.5070507@rzg.mpg.de>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Soddemann <Thomas.Soddemann@rzg.mpg.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2002-12-06 at 09:16, Thomas Soddemann wrote:
> Hi,
> 
> does anybody know whether there is there a possibility to use ide-scsi 
> in connection with an IDE HD?

Basically no - IDE disks don't support ATAPI.

