From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v2 3/6 2.6.29-rc] cxgb3i - Outgoing pdus need to observe skb's MAX_SKB_FRAGS
Date: Tue, 17 Feb 2009 15:19:53 -0600
Message-ID: <499B29F9.1050803@cs.wisc.edu>
References: <200902140538.n1E5csvZ014339@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <200902140538.n1E5csvZ014339-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Karen Xie wrote:
> [PATCH v2 3/6 2.6.29-rc] cxgb3i - Outgoing pdus need to observe skb's MAX_SKB_FRAGS
> 
> From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> 
> Need to make sure the outgoing pdu can fit into a single skb.
> When calulating the max. outgoing pdu payload size, take into consideration of
> - data can be held in the skb's fragment list, assume 512 bytes per fragment, and
> - data can be held in the headroom.
>  
> Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
