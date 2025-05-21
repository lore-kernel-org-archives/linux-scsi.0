Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AEB23C8AE
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 23:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747868899; cv=none; b=nh21kl3dvcoO9SfUW0k0naMpM2ucMyvXrlH2Bg3RtK8WKuTI3bsgGcXcyxtAG2ikHInE1qIOZPcZFc8Om+ii97Q5FeX2qTwfMd4T183Y8a3ZDl7p5And02bO3Nvyw3tuxqWwCWJ6dIenny5QNE+rpoTBv4XH7W74W7DAOUoxF/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747868899; c=relaxed/simple;
	bh=a61dKM+sOIM0W5tW48Pob5ugW7t7gLWfNmxKzXb3ZUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lXmULwZT2b5gSHSSVHvqNajmI5R3VM7P9OTSMqGS1br7j9cbZi8DQ5/QIivBRjAK7cf1X4N11oDq8tm+c/tWazHtpmKSivbzohOcno3S0LGuzLsjmba5tw38+YkIKxEg+4TKrWxVfZu/2RODxsjju5ptdUncs9TSfavr2P91tZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=bepJksC9; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="bepJksC9"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id HnEyurB2kVkcRHsXiug0WP; Wed, 21 May 2025 23:08:10 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id HsXhu39ouhHAkHsXiu8hLM; Wed, 21 May 2025 23:08:10 +0000
X-Authority-Analysis: v=2.4 cv=YsIJRZYX c=1 sm=1 tr=0 ts=682e5cda
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=efVMuJ2jJG67FGuSm7J3ww==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=1XWaLZrsAAAA:8
 a=Ikd4Dj_1AAAA:8 a=8AirrxEcAAAA:8 a=Q-fNiiVtAAAA:8 a=P-IC7800AAAA:8
 a=vggBfdFIAAAA:8 a=kVnt-_iYu5xLd2SthAEA:9 a=QEXdDO2ut3YA:10
 a=y1Q9-5lHfBjTkpIzbSAN:22 a=ST-jHhOKWsTCqRlWije3:22 a=d3PnA9EDa4IxuAV0gXij:22
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OOmlzPBtUod15P9R+5e8Nw5tXEBviOvhwK88h6lKd3o=; b=bepJksC97ML9IvPhF7R0GsUE39
	iDt8KE0iZROL8TgvVT9PzNwW9sKKBRJIhmxUFgGMA4kRLMqCqmH91zI6xfv4az4R0oAueD2N1pUNA
	bervFDvFSZHb9jsR3chCY5xthPhQ0Cl/+MKfCN4IxcuwZC/eNjc6eJT48KNq7zmhswlELymKhpwJ9
	IE+aST75QjzkaqovTJCwxM0OOGiP/qFBJJhUXJj2Q+x9IJWsqcd9FDDhPrBZF1ucKo6mywih6j/rj
	bOl+lJogaVAvYC+9j/8hT2QnS2oen4Ab7a1MoDN1moAJWQOY79Q+3qkhREtWoNHjvcT3rbLY8DX1O
	KwaRGQqw==;
Received: from [177.238.17.151] (port=34848 helo=[192.168.0.27])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uHsXZ-00000000Kdy-1IG9;
	Wed, 21 May 2025 18:08:01 -0500
Message-ID: <ebba72b4-9245-4be5-8f0d-87f7b326d468@embeddedor.com>
Date: Wed, 21 May 2025 17:07:28 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 8/8] net: core: Convert
 dev_set_mac_address_user() to use struct sockaddr_storage
To: Kees Cook <kees@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Cosmin Ratiu <cratiu@nvidia.com>, Vladimir Oltean <vladimir.oltean@nxp.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Kory Maincent <kory.maincent@bootlin.com>, Maxim Georgiev
 <glipus@gmail.com>, netdev@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Mike Christie <michael.christie@oracle.com>,
 Max Gurtovoy <mgurtovoy@nvidia.com>, Maurizio Lombardi
 <mlombard@redhat.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Mingzhe Zou <mingzhe.zou@easystack.cn>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, Lei Yang
 <leiyang@redhat.com>, Ido Schimmel <idosch@nvidia.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 Paul Fertser <fercerpav@gmail.com>, Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>, Hayes Wang
 <hayeswang@realtek.com>, Douglas Anderson <dianders@chromium.org>,
 Grant Grundler <grundler@chromium.org>, Jay Vosburgh <jv@jvosburgh.net>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Jiri Pirko <jiri@resnulli.us>,
 Aleksander Jan Bajkowski <olek2@wp.pl>, Philipp Hahn <phahn-oss@avm.de>,
 Eric Biggers <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Xiao Liang <shaw.leon@gmail.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-wpan@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20250521204310.it.500-kees@kernel.org>
 <20250521204619.2301870-8-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20250521204619.2301870-8-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.17.151
X-Source-L: No
X-Exim-ID: 1uHsXZ-00000000Kdy-1IG9
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.27]) [177.238.17.151]:34848
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLzMusxBGQK6qPMdy8ZTQeY7UoM3LwcJZPRB7aMVQov5crcZKrZ/cEIN1T0DEgZnYIn7rPuHfiIDZ3R2dQQ7lVDwzXPQIsjwhrCN4w7E1ImY1Ack1tCZ
 N3MB/oUL30+B0MtW1XKLzsWzGUudFp7qtMI8wvL5hW0/6mZJRQdmlPmiDjERKTF4VhiW0Bn09ZAR+qyHvokr9eUBWUARctSswzv8OXpEmCBjZtomNXRSlMq7



On 21/05/25 14:46, Kees Cook wrote:
> Convert callers of dev_set_mac_address_user() to use struct
> sockaddr_storage. Add sanity checks on dev->addr_len usage.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>

Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
-Gustavo

> ---
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Andrew Lunn <andrew+netdev@lunn.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Cc: Cosmin Ratiu <cratiu@nvidia.com>
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Cc: Florian Fainelli <florian.fainelli@broadcom.com>
> Cc: Kory Maincent <kory.maincent@bootlin.com>
> Cc: Maxim Georgiev <glipus@gmail.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: <netdev@vger.kernel.org>
> ---
>   include/linux/netdevice.h |  2 +-
>   drivers/net/tap.c         | 14 +++++++++-----
>   drivers/net/tun.c         |  8 +++++++-
>   net/core/dev_api.c        |  5 +++--
>   net/core/dev_ioctl.c      |  6 ++++--
>   5 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b4242b997373..adb14db25798 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4216,7 +4216,7 @@ int netif_set_mac_address(struct net_device *dev, struct sockaddr_storage *ss,
>   			  struct netlink_ext_ack *extack);
>   int dev_set_mac_address(struct net_device *dev, struct sockaddr_storage *ss,
>   			struct netlink_ext_ack *extack);
> -int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
> +int dev_set_mac_address_user(struct net_device *dev, struct sockaddr_storage *ss,
>   			     struct netlink_ext_ack *extack);
>   int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
>   int dev_get_port_parent_id(struct net_device *dev,
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index d4ece538f1b2..bdf0788d8e66 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -923,7 +923,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>   	unsigned int __user *up = argp;
>   	unsigned short u;
>   	int __user *sp = argp;
> -	struct sockaddr sa;
> +	struct sockaddr_storage ss;
>   	int s;
>   	int ret;
>   
> @@ -1000,16 +1000,17 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>   			return -ENOLINK;
>   		}
>   		ret = 0;
> -		dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);
> +		dev_get_mac_address((struct sockaddr *)&ss, dev_net(tap->dev),
> +				    tap->dev->name);
>   		if (copy_to_user(&ifr->ifr_name, tap->dev->name, IFNAMSIZ) ||
> -		    copy_to_user(&ifr->ifr_hwaddr, &sa, sizeof(sa)))
> +		    copy_to_user(&ifr->ifr_hwaddr, &ss, sizeof(ifr->ifr_hwaddr)))
>   			ret = -EFAULT;
>   		tap_put_tap_dev(tap);
>   		rtnl_unlock();
>   		return ret;
>   
>   	case SIOCSIFHWADDR:
> -		if (copy_from_user(&sa, &ifr->ifr_hwaddr, sizeof(sa)))
> +		if (copy_from_user(&ss, &ifr->ifr_hwaddr, sizeof(ifr->ifr_hwaddr)))
>   			return -EFAULT;
>   		rtnl_lock();
>   		tap = tap_get_tap_dev(q);
> @@ -1017,7 +1018,10 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
>   			rtnl_unlock();
>   			return -ENOLINK;
>   		}
> -		ret = dev_set_mac_address_user(tap->dev, &sa, NULL);
> +		if (tap->dev->addr_len > sizeof(ifr->ifr_hwaddr))
> +			ret = -EINVAL;
> +		else
> +			ret = dev_set_mac_address_user(tap->dev, &ss, NULL);
>   		tap_put_tap_dev(tap);
>   		rtnl_unlock();
>   		return ret;
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7babd1e9a378..1207196cbbed 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3193,7 +3193,13 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>   
>   	case SIOCSIFHWADDR:
>   		/* Set hw address */
> -		ret = dev_set_mac_address_user(tun->dev, &ifr.ifr_hwaddr, NULL);
> +		if (tun->dev->addr_len > sizeof(ifr.ifr_hwaddr)) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ret = dev_set_mac_address_user(tun->dev,
> +					       (struct sockaddr_storage *)&ifr.ifr_hwaddr,
> +					       NULL);
>   		break;
>   
>   	case TUNGETSNDBUF:
> diff --git a/net/core/dev_api.c b/net/core/dev_api.c
> index 6011a5ef649d..1bf0153195f2 100644
> --- a/net/core/dev_api.c
> +++ b/net/core/dev_api.c
> @@ -84,14 +84,15 @@ void dev_set_group(struct net_device *dev, int new_group)
>   	netdev_unlock_ops(dev);
>   }
>   
> -int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
> +int dev_set_mac_address_user(struct net_device *dev,
> +			     struct sockaddr_storage *ss,
>   			     struct netlink_ext_ack *extack)
>   {
>   	int ret;
>   
>   	down_write(&dev_addr_sem);
>   	netdev_lock_ops(dev);
> -	ret = netif_set_mac_address(dev, (struct sockaddr_storage *)sa, extack);
> +	ret = netif_set_mac_address(dev, ss, extack);
>   	netdev_unlock_ops(dev);
>   	up_write(&dev_addr_sem);
>   
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index fff13a8b48f1..616479e71466 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -572,9 +572,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>   		return dev_set_mtu(dev, ifr->ifr_mtu);
>   
>   	case SIOCSIFHWADDR:
> -		if (dev->addr_len > sizeof(struct sockaddr))
> +		if (dev->addr_len > sizeof(ifr->ifr_hwaddr))
>   			return -EINVAL;
> -		return dev_set_mac_address_user(dev, &ifr->ifr_hwaddr, NULL);
> +		return dev_set_mac_address_user(dev,
> +						(struct sockaddr_storage *)&ifr->ifr_hwaddr,
> +						NULL);
>   
>   	case SIOCSIFHWBROADCAST:
>   		if (ifr->ifr_hwaddr.sa_family != dev->type)

