From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC-v2 10/12] iser-target: Add logic for verbs
Date: Tue, 2 Apr 2013 09:18:43 +0300
Message-ID: <515A7843.1030804@mellanox.com>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org> <1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 23/03/2013 01:55, Nicholas A. Bellinger wrote:
> +++ b/drivers/infiniband/ulp/isert/isert_verbs.h
> @@ -0,0 +1,5 @@
> +extern void isert_connect_release(struct isert_conn *);
> +extern void isert_put_conn(struct isert_conn *);
> +extern int isert_cma_handler(struct rdma_cm_id *, struct rdma_cm_event *);
> +extern int isert_post_recv(struct isert_conn *, u32);
> +extern int isert_post_send(struct isert_conn *, struct iser_tx_desc *);

why use extern here? maybe a left over from V1?
