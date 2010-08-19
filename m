From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Thu, 19 Aug 2010 17:50:11 -0400
Message-ID: <4C6DA713.40601@teksavvy.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>	<AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com> <yq1fwyamq9s.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1fwyamq9s.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10-08-19 02:05 PM, Martin K. Petersen wrote:
>I'm only aware of one drive that currently
> supports more than 512 bytes of payload and it also caps at 4KB.

SSDs based upon the Indilinx Barefoot controller support
more or less "infinite" payload for TRIM, with no cap.
But it predates idword[105], so just has a zero there.

OCZ Vertex-LE specifies a single sector of payload.

Those are the ones I know about and have on hand here for TRIM.

Cheers
