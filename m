From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: HBA recommended as FC target
Date: Fri, 18 Aug 2017 09:25:55 -0400
Message-ID: <CAAzz28hH10wsJhLnQP5WeNLxnn_qbS4MWCHE1jtPLdYhfoCaEw@mail.gmail.com>
References: <20170818123623.GA4074@glanzmann.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170818123623.GA4074@glanzmann.de>
Sender: target-devel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2017 at 8:36 AM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello,
> I look for a FC HBA that works with the Linux target. Can somone
> recommend a HBA type to me?
>
> Cheers,
>         Thomas

Hello

Any of the Qlogic qla24xx or qla25xx and higher that allow you to
disable initiator mode will work.
I use qla25xx 8Gbit in all my Target arrays.

Thanks
Laurence
