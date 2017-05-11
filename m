From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] target: remove dead code
Date: Thu, 11 May 2017 13:39:34 -0700
Message-ID: <eb45ee9e-8dc7-c1a2-25c7-62fa5b962e08@linux.vnet.ibm.com>
References: <20170509214604.GA7643@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170509214604.GA7643@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/09/2017 02:46 PM, Gustavo A. R. Silva wrote:
> Local variable _ret_ is assigned to a constant value and it is never
> updated again. Remove this variable and the dead code it guards.
> 
> Addresses-Coverity-ID: 140761
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
