From: Doug Ledford <dledford@redhat.com>
Subject: Re: [GIT PULL] delete decade+ obsolete aic7xxx_old driver
Date: Fri, 08 Nov 2013 11:13:03 -0500
Message-ID: <527D0D8F.5010001@redhat.com>
References: <20131108160446.GA16190@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131108160446.GA16190@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/08/2013 11:04 AM, Paul Gortmaker wrote:

> Paul Gortmaker (1):
>        scsi: delete decade+ obsolete aic7xxx_old driver
>
>   Documentation/scsi/00-INDEX             |     2 -
>   Documentation/scsi/aic7xxx_old.txt      |   511 --
>   MAINTAINERS                             |     1 -
>   drivers/scsi/Kconfig                    |    41 -
>   drivers/scsi/Makefile                   |     1 -
>   drivers/scsi/aic7xxx_old.c              | 11149 ------------------------------
>   drivers/scsi/aic7xxx_old/aic7xxx.h      |    28 -
>   drivers/scsi/aic7xxx_old/aic7xxx.reg    |  1401 ----
>   drivers/scsi/aic7xxx_old/aic7xxx.seq    |  1539 -----
>   drivers/scsi/aic7xxx_old/aic7xxx_proc.c |   270 -
>   drivers/scsi/aic7xxx_old/aic7xxx_reg.h  |   629 --
>   drivers/scsi/aic7xxx_old/aic7xxx_seq.c  |   817 ---
>   drivers/scsi/aic7xxx_old/scsi_message.h |    49 -
>   drivers/scsi/aic7xxx_old/sequencer.h    |   135 -
>   14 files changed, 16573 deletions(-)
>   delete mode 100644 Documentation/scsi/aic7xxx_old.txt
>   delete mode 100644 drivers/scsi/aic7xxx_old.c
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.h
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.reg
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.seq
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_proc.c
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_reg.h
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_seq.c
>   delete mode 100644 drivers/scsi/aic7xxx_old/scsi_message.h
>   delete mode 100644 drivers/scsi/aic7xxx_old/sequencer.h
>

Farewell old friend...don't let the door hit you in the ass on the way 
out ;-)
