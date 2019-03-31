From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/2] scsi: pm8001: fix spelling mistake, interupt -> interrupt
Date: Sun, 31 Mar 2019 19:43:49 +0200
Message-ID: <CAMGffEmMjSc-juQcO9eQ6AVc9OTh8POd4Xi0SbVYtt5Fk=NyQw@mail.gmail.com>
References: <20190329234423.5611-1-colin.king@canonical.com> <20190329234423.5611-3-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190329234423.5611-3-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu <lindar_liu@usish.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 30, 2019 at 12:44 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Rename the functions pm8001_chip_is_our_interupt,
> pm80xx_chip_is_our_interupt and function pointer is_our_interrupt
> to fix spelling mistakes.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Thanks, Colin,
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>

-- 
Jack Wang
Linux Kernel Developer

1&1 IONOS Cloud GmbH | Greifswalder Str. 207 | 10405 Berlin | Germany
Phone: +49 30 57700-8042 | Fax: +49 30 57700-8598
E-mail: jinpu.wang@cloud.ionos.com | Web: www.ionos.de


Head Office: Berlin, Germany
District Court Berlin Charlottenburg, Registration number: HRB 125506 B
Executive Management: Christoph Steffens, Matthias Steinberg, Achim Weiss

Member of United Internet

This e-mail may contain confidential and/or privileged information. If
you are not the intended recipient of this e-mail, you are hereby
notified that saving, distribution or use of the content of this
e-mail in any way is prohibited. If you have received this e-mail in
error, please notify the sender and delete the e-mail.
