From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC-v4 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
Date: Sun, 21 Apr 2013 17:13:37 +0300
Message-ID: <5173F411.1030806@mellanox.com>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org> <1365799962-13543-10-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365799962-13543-10-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 12/04/2013 23:52, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger<nab@linux-iscsi.org>
>
> This patch adds support for iSCSI Extensions for RDMA target mode,
> and includes CQ pooling per isert_device context distributed across
> multiple active iser target sessions.

Cool, feel free to ad my S.O.B here

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
