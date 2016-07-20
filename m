From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: fix panic when add the second TCP
 connection to iSCSI session
Date: Wed, 20 Jul 2016 13:27:21 -0700
Message-ID: <1469046441.13881.7.camel@haakon3.risingtidesystems.com>
References: <20160711221544.42291-1-li.feng@oracle.com>
	 <CAEK8JBCZstYOEHhjkSZmoy9ga5YfKQyde7UVqJhu0gsTmi1AiQ@mail.gmail.com>
	 <CAEK8JBD8OJJ9YgFFSt9fni50iVffFbUwkFFUBNGGdS-75foZBA@mail.gmail.com>
	 <E024F01B-DD5C-448D-9E71-163D802D677F@calsoftinc.com>
	 <CAEK8JBDAqp+yRJC9=Qu3yhwzAX3GQjmYyPgt3pcw3qNJQ7e_RA@mail.gmail.com>
	 <A58D6B93-9933-4B0B-BDF5-B10D5A8B620C@calsoftinc.com>
	 <CAEK8JBDJP29kvcbh3wzLPUy07+9bLrXSD7EKCMTHQ5BUi=cTng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54938 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbcGTU1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 16:27:24 -0400
In-Reply-To: <CAEK8JBDJP29kvcbh3wzLPUy07+9bLrXSD7EKCMTHQ5BUi=cTng@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Feng Li <lifeng1519@gmail.com>
Cc: Sumit Rai <sumit.rai@calsoftinc.com>, agrover@redhat.com, "varun@chelsio.com" <varun@chelsio.com>, Herbert Xu <herbert@gondor.apana.org.au>, Roland Dreier <roland@purestorage.com>, Zhu Lingshan <lszhu@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

Hi Feng & Co,

Apologies for the delayed follow-up.

On Tue, 2016-07-19 at 10:10 +0800, Feng Li wrote:
> Okay, thanks.
> 
> Anyone could help review this patch and merge into upstream?
> 

Applied to target-pending/for-next, with a CC' to 3.14+ stable.

Thanks Feng + Sumit for tracking this down.



