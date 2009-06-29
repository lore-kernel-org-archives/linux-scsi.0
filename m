From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Allow ATA_ passthrough command through sg.
Date: Mon, 29 Jun 2009 19:26:44 -0400
Message-ID: <4A494DB4.2060908@garzik.org>
References: <1246310665-31727-1-git-send-email-gwendal@google.com> <20090629232045.14a426b6@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090629232045.14a426b6@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Gwendal Grignou <gwendal@google.com>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
> On Mon, 29 Jun 2009 14:24:25 -0700
> Gwendal Grignou <gwendal@google.com> wrote:
> 
>> We can already send ATA specific commands using /dev/sd device files.
>> This patch allow to use /dev/sg device files as well.
> 
> That seems a very very bad idea. The point of the filters is only to
> allow through commands that are safe for all users with read or write
> permission to use.
> 
> Backdooring it with arbitary passthrough ATA12/ATA16 commands doesn't
> seem very wise.

Indeed.  This pretty much defeats the filter for all ATA commands, 
including ones that can brick your drive.

	Jeff



