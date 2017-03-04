From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 11/16] media: utilize new cdev_device_add helper
 function
Date: Sat, 4 Mar 2017 15:57:40 -0700
Message-ID: <9941530f-c36a-3fa0-6f5b-87d779f5988c@deltatee.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-12-git-send-email-logang@deltatee.com>
 <8eff8408-1681-a59d-3b61-8fd5dab73af1@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <8eff8408-1681-a59d-3b61-8fd5dab73af1-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Hans Verkuil <hansverk-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



On 27/02/17 02:02 AM, Hans Verkuil wrote:
> FYI: this patch series didn't turn up at the linux-media mailinglist for
> some reason.

Strange my mail logs show success (see below) but none of the lists at
vger.kernel.org picked up either v1 or v2. I don't know what to do about
that. My previous other patch series doesn't have an issue and I'm using
the exact same setup. Maybe I'm sending to too many lists at once with
this series? I'm not really sure.

Logan


2017-02-25 23:40:37 1chsTZ-0004fx-8Y => linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
2017-02-25 23:40:37 1chsTZ-0004fx-8Y -> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
R=dnslookup T=remote_smtp H=vger.kernel.org [209.132.180.67] C="250
2.7.1 Looks like Linux source DIFF email.. BF:<H 0>; S1751779AbdBZGki"
