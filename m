From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 18:17:40 -0700
Message-ID: <53AA2334.8000109@vlnb.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A89B0F.4040300@cs.wisc.edu> <yq1r42fgjbp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1r42fgjbp.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen, on 06/23/2014 06:58 PM wrote:
>>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:
>>> + unsigned int xfer_len = blk_rq_bytes(scmd->request);
>
> Mike> Can you do bidi and dif/dix?
>
> Nope.

Correction: at the moment.

There is a proposal of READ GATHERED command, which is bidirectional and potentially 
DIF/DIX.

Vlad
