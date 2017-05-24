From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: remove dead code
Date: Tue, 23 May 2017 20:30:17 -0700
Message-ID: <1495596617.27407.33.camel@haakon3.risingtidesystems.com>
References: <20170509214604.GA7643@embeddedgus>
         <eb45ee9e-8dc7-c1a2-25c7-62fa5b962e08@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb45ee9e-8dc7-c1a2-25c7-62fa5b962e08@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-11 at 13:39 -0700, Tyrel Datwyler wrote:
> On 05/09/2017 02:46 PM, Gustavo A. R. Silva wrote:
> > Local variable _ret_ is assigned to a constant value and it is never
> > updated again. Remove this variable and the dead code it guards.
> > 
> > Addresses-Coverity-ID: 140761
> > Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> > ---
> 
> Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> 

Applied to target-pending/for-next.

Thanks Gustavo + Tyrel.
