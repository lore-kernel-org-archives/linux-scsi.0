From: Benjamin LaHaise <bcrl@redhat.com>
Subject: Re: 2.5.14 error: ini9100u.c
Date: Thu, 11 Jul 2002 19:21:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <agl4af$6hm$2@main.gmane.org>
References: <1020675649.20692.6.camel@localhost.localdomain> <3CD74E41.D39C1F23@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CD74E41.D39C1F23@torque.net>; from dougg@torque.net on Mon, May 06, 2002 at 11:47:13PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: angus <angus@mcm.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, May 06, 2002 at 11:47:13PM -0400, Douglas Gilbert wrote:
> -#error Please convert me to Documentation/DMA-mapping.txt
> +/* #error Please convert me to Documentation/DMA-mapping.txt */

Please read the document the comment points to, *then* rewrite the 
patch.

		-ben
