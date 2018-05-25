From: Josh Boyer <jwboyer@kernel.org>
Subject: Re: [PATCH v2 1/1] qed: Add firmware 8.37.2.0
Date: Fri, 25 May 2018 08:07:17 -0400
Message-ID: <CA+5PVA4SVAz6O5ioK-mbhzpULxQWbBK1DTXrFKwgQkFW7WxB5A@mail.gmail.com>
References: <20180521135141.11091-1-rahul.verma@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180521135141.11091-1-rahul.verma@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Rahul Verma <rahul.verma@cavium.com>
Cc: Kyle McMartin <kyle@kernel.org>, netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Linux Firmware <linux-firmware@kernel.org>, Ben Hutchings <ben@decadent.org.uk>, ariel.elior@cavium.com
List-Id: linux-scsi@vger.kernel.org

On Mon, May 21, 2018 at 10:25 AM Rahul Verma <rahul.verma@cavium.com> wrote:

> This patch add a new qed firmware with fixes and added
> support for new features.
> -Fix aRFS for tunneled traffic without inner IP.
> -Fix chip configuration which may fail under heavy traffic conditions.
> -Fix iSCSI recovery flow.
> -Support receiving any-VNI in VXLAN and GENEVE RX classification.
> -Support additional RoCE statistics for error cases.
> -Support RoCE T10DIF.

> v1->v2:
> Added signoff for Ariel Elior.

> Signed-off-by: Rahul Verma <rahul.verma@cavium.com>
> Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
> ---
>   WHENCE                                  |   1 +
>   qed/qed_init_values_zipped-8.37.2.0.bin | Bin 0 -> 867472 bytes
>   2 files changed, 1 insertion(+)
>   create mode 100755 qed/qed_init_values_zipped-8.37.2.0.bin

Applied and pushed out.

josh
