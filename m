From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: 02 Oct 2002 20:51:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1033588299.23661.34.camel@irongate.swansea.linux.org.uk>
References: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Scott Merritt <Scsi@PragmaSoft.com>, linux-scsi@vger.kernel.org

On Wed, 2002-10-02 at 19:10, Bryan Henderson wrote:
> But when we speak of inhibiting partition table reading, I think that's
> another (missing) feature:  I should be able to control whether Linux
> considers there to be partitions on my disk or not (and change the fact

Why do you want to. Linux always offers you the entire disk anyway. 

