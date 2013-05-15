From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2, part 1 3/9] PCI: Convert alloc_pci_dev(void) to
 pci_alloc_dev(bus) instead
Date: Thu, 16 May 2013 07:29:31 +1000
Message-ID: <1368653371.9603.18.camel@pasglop>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
 <1368461313-4371-4-git-send-email-jiang.liu@huawei.com>
 <CAE9FiQVKKKmZRQ8CcKCzU8Gqzwb5SjWYagVB2OZiRqbSWXVpiw@mail.gmail.com>
 <5191F53E.4000305@cn.fujitsu.com> <51925136.5050302@gmail.com>
 <CAE9FiQWO-jR5y35kKiW0m6gVR54ZyRsBsdhP4BmFLSsDzCS3rA@mail.gmail.com>
 <51926CF6.1050706@gmail.com>
 <CAE9FiQWXN_ETRFPb5oFx-6LXyuHviX3h3NXCQKjcxtv2Uma-JA@mail.gmail.com>
 <51939E16.9090105@gmail.com>
 <CAE9FiQUXrOmN0rkvOwE1G_acEGY3-gouzaXjBMT7EE6uAqvuZA@mail.gmail.com>
 <51939FB1.20203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <51939FB1.20203@gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Liu Jiang <liuj97@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>, Linux-Scsi <linux-scsi@vger.kernel.org>, Myron Stowe <myron.stowe@redhat.com>, David Airlie <airlied@linux.ie>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linuxppc-dev@lists.ozlabs.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <jbottomley@parallels.com>, "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>, Paul Mackerras <paulus@samba.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, Jiang Liu <jiang.liu@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-05-15 at 22:46 +0800, Liu Jiang wrote:
>        I don't know any OF exports, could you please help to CC
> some OF experts?

I wrote that code I think. Sorry, I've missed the beginning of the
thread, what is the problem ?

Cheers,
Ben.
