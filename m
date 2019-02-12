From: Josh Boyer <jwboyer@kernel.org>
Subject: Re: [PATCH 1/1] bnx2x: Add FW 7.13.11.0.
Date: Tue, 12 Feb 2019 07:37:23 -0500
Message-ID: <CA+5PVA4-VWwMTj4NYaAjUZ=11LFVD02isqB4KkXBBKgSAGp8vg@mail.gmail.com>
References: <20190208085704.26959-1-rahul.verma@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190208085704.26959-1-rahul.verma@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Rahul Verma <rahul.verma@cavium.com>
Cc: Kyle McMartin <kyle@kernel.org>, netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Linux Firmware <linux-firmware@kernel.org>, Ben Hutchings <ben@decadent.org.uk>, ariel.elior@cavium.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 9, 2019 at 11:06 PM Rahul Verma <rahul.verma@cavium.com> wrote:
>
> From: Rahul Verma <Rahul.Verma@cavium.com>
>
> This patch adds new FW for bnx2x, which adds the following:
>  - TX VLAN filtering support.
>  - Enable TPA only for packets without VLAN.
>
> It also addresses few critical issues,
>  - Fairness algorithm misbehaviour when minimum bandwidth configured
>    for all PFs.
>  - Error recovery issue on TAPE devices.
>  - FW not discarding FIP frames that are not designated to PF.
>  - Kernel driver initialization failure after preboot driver.
>  - VxLAN stops working after sending inner IP fragmented traffic.
>  - Issues in the following FW flows:
>     SD VLAN update, TX packet drop, packet padding flow, vlan add/remove.
>
> Signed-off-by: Sudarsana Reddy Kalluru <Sudarsana.Kalluru@cavium.com>
> Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
> Signed-off-by: Rahul Verma <Rahul.Verma@cavium.com>

Applied and pushed out.

josh
