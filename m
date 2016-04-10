From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 08/16] iscsi-target: add void (*iscsit_get_r2t_ttt)()
Date: Sun, 10 Apr 2016 20:51:44 +0300
Message-ID: <570A92B0.9000109@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <2f71b7720d07231faa12ffba830681f1d7ac07da.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <2f71b7720d07231faa12ffba830681f1d7ac07da.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org


> Add void (*iscsit_get_r2t_ttt)() to
> struct iscsit_transport, iscsi-target
> uses this callback to get
> r2t->targ_xfer_tag.

Your driver allocates ttt's? That looks like bad
layering to me. This definitely deserves an explanation...
