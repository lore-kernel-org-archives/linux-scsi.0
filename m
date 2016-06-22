From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Wed, 22 Jun 2016 08:23:56 -0400 (EDT)
Message-ID: <1767566647.539320.1466598236927.JavaMail.zimbra@redhat.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com> <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com> <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com> <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com> <57693C6A.3020805@gmail.com> <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA@mail.gmail.com> <CAANLjFpeL0AkuGW-q5Bmm-dff0UqFOM_sAOaG7=vyqmwnOoTcQ@mail.gmail.com> <86d4404a-fa6a-72de-8e83-827072c308b5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86d4404a-fa6a-72de-8e83-827072c308b5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Robert LeBlanc" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "Sagi Grimberg" <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Sent: Wednesday, June 22, 2016 4:18:31 AM
> Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
> 
> On 06/21/2016 10:26 PM, Robert LeBlanc wrote:
> > Srpt keeps crashing couldn't test
> 
> If this is reproducible with the latest rc kernel or with any of the
> stable kernels please report this in a separate e-mail, together with
> the crash call stack and information about how to reproduce this.
> 
> Thanks,
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Robert

I am exercising the ib_srpt configured vi a targetlio very heavily in 4.7.0-rc1.
I have no crashes or issues.
I also had 4.5 running ib_srpt with no crashes, although I had some other timeouts etc depending on the load.

What sort of crashes are you talking about ?
Does the system crash, ib_srpt dump stack ?

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
